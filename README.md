# Delivery Management System

Hệ thống quản lý software delivery dựa hoàn toàn trên markdown.
Hỗ trợ 2 môi trường: **Claude Code** (tự động hóa hoàn toàn) và **Chat AI** (Rakuten AI, ChatGPT... qua prompt cards).

---

## Cấu trúc thư mục

```
delivery-system/
│
├── input/                          ← Team nhập liệu vào đây
│   ├── _template.md                          Template tracking file
│   ├── _project-context-template.md          Template project context
│   └── [PROJECT-CODE]/                       1 folder per project (VD: HAYK, AUTH, CL)
│       ├── project-context.md                Hồ sơ dự án — nhập 1 lần khi kickoff
│       ├── project.md                        Tracking file — Waterfall
│       ├── sprint-N.md                       Tracking file — Scrum
│       ├── board.md                          Tracking file — Kanban
│       ├── gates.md                          Gate checklist (8 phase transitions)
│       └── transcript-YYYY-MM-DD.md          Meeting transcript / notes
│
├── processed/                      ← Pipeline tự tạo, không chỉnh tay
│   └── [PROJECT-CODE]/
│       ├── collected-YYYY-MM-DD.md    Input đã chuẩn hóa + flags
│       ├── meeting-YYYY-MM-DD.md      Transcript đã parse thành structured data
│       ├── metrics-YYYY-MM-DD.md      Số liệu đã tính (completion rate, risk score...)
│       └── insights-YYYY-MM-DD.md     Phân tích nguyên nhân + khuyến nghị
│
├── output/                         ← Báo cáo cuối cùng, sẵn sàng gửi stakeholder
│   ├── reports/
│   │   ├── [PROJECT-CODE]/
│   │   │   └── YYYY-MM-DD-sprint-report.md    Báo cáo chi tiết từng project
│   │   └── YYYY-MM-DD-executive-summary.md    Tổng hợp tất cả projects (≥2)
│   ├── alerts/
│   │   └── [PROJECT-CODE]/
│   │       └── YYYY-MM-DD-alert.md            Cảnh báo rủi ro (khi risk ≥ 5/10)
│   └── meetings/
│       └── [PROJECT-CODE]/
│           └── YYYY-MM-DD-[tên].md            Meeting minute từ transcript
│
├── gates/
│   └── pipeline-gates.md           ← Gate checklist gốc (copy vào input/ khi init project)
│
├── prompts/                        ← Prompt cards dùng với chat AI (Rakuten AI...)
│   ├── README.md                      Hướng dẫn + ví dụ thực tế
│   ├── capture.md                     Capture input từ Teams/Email/meeting
│   ├── daily-check.md                 Kiểm tra nhanh đầu ngày
│   ├── sprint-report.md               Tạo báo cáo đầy đủ
│   └── gate-check.md                  Kiểm tra gate trước khi chuyển phase
│
└── .claude/
    ├── agents/                     ← Subagents của Claude Code pipeline
    │   ├── data-collector.md          Đọc & chuẩn hóa input
    │   ├── transcript-parser.md       Parse meeting transcript
    │   ├── meeting-collector.md       Merge meeting data vào sprint
    │   ├── metrics-analyzer.md        Tính KPIs và risk score
    │   ├── insight-generator.md       Phân tích & đề xuất
    │   ├── reporter.md                Tạo output markdown
    │   └── capy.md                    Senior Delivery Manager AI
    └── commands/                   ← Slash commands của Claude Code
        ├── init-project.md            /init-project
        └── capture.md                 /capture
```

---

## Vai trò từng thư mục

### `input/` — Nơi team nhập liệu

Toàn bộ data thực tế của dự án được lưu tại đây. Team cập nhật thủ công hoặc qua `/capture`.

Mỗi folder project chứa **2 loại file khác nhau về bản chất**:

#### project-context.md — Hồ sơ dự án (nhập 1 lần)

Nền tảng cố định của dự án. Nhập khi kickoff, cập nhật khi có thay đổi lớn (re-plan, thay team, scope change).

| Nội dung | Trả lời câu hỏi |
|---|---|
| Team roster (name, role, allocation, project song song) | Ai đang làm? Bao nhiêu % thời gian? |
| Timeline (start, target delivery, milestones) | Deadline khi nào? Các mốc quan trọng là gì? |
| Scope (số deliverables, original scope, acceptance criteria) | Cam kết ban đầu là gì? |
| Constraints (nghỉ phép, dependency, approval gate) | Có ràng buộc nào ảnh hưởng delivery không? |

Pipeline dùng file này để tính `days_to_deadline`, `timeline_elapsed_%`, phát hiện scope creep, và đánh giá risk chính xác hơn. Nếu thiếu file này, các subagent sẽ phân tích "trong bóng tối" — có số nhưng không có ngưỡng để đánh giá.

> **Dễ nhớ:** `project-context.md` = hồ sơ ký khi bắt đầu. `tracking file` = nhật ký thi công hàng ngày.

#### Tracking file — Trạng thái thực tế (cập nhật liên tục)

1 trong 3 loại tùy mô hình quản lý:

| File          | Dùng khi  | Đặc điểm                                                         |
| ------------- | --------- | ---------------------------------------------------------------- |
| `project.md`  | Waterfall | 1 file cả vòng đời, có `Current Phase`, có cột Phase trong Tasks |
| `sprint-N.md` | Scrum     | 1 file per sprint, tạo sprint-2.md khi sprint mới bắt đầu        |
| `board.md`    | Kanban    | 1 file rolling, không có end date, có section Archive            |

#### Các file khác trong folder project

- `gates.md` — checklist 8 gate transitions, điền Pass ✓ trước khi chuyển phase
- `transcript-*.md/.vtt` — meeting notes hoặc Zoom transcript, pipeline tự parse

---

### `processed/` — Bộ nhớ trung gian của pipeline

Thư mục này **không dành cho người đọc** — chỉ dành cho các agent đọc qua lại với nhau.
Tồn tại vì agents trong Claude Code không thể truyền data trực tiếp, chỉ giao tiếp qua file.

| File             | Tạo bởi           | Nội dung                                                                                   |
| ---------------- | ----------------- | ------------------------------------------------------------------------------------------ |
| `collected-*.md` | data-collector    | Input đã chuẩn hóa: tasks gom 1 bảng, flags OVERDUE/BLOCKED/INCOMPLETE, phase distribution |
| `meeting-*.md`   | transcript-parser | Transcript đã phân loại: action items, decisions, blockers, risks tách riêng               |
| `metrics-*.md`   | metrics-analyzer  | Số liệu tính toán: completion rate, risk score 0–10, workload per owner, phase bottleneck  |
| `insights-*.md`  | insight-generator | Phân tích: root cause, hidden risks, khuyến nghị hành động cụ thể                          |

> **Không chỉnh tay** — sẽ bị ghi đè lần chạy tiếp theo.
> **Dùng để debug** — khi report sai, xem `collected-*.md` để biết data đầu vào có vấn đề không.

---

### `output/` — Tài liệu gửi stakeholder

Kết quả cuối cùng, định dạng markdown sạch, sẵn sàng paste lên Confluence hoặc gửi email.

| Thư mục               | Nội dung                                                      | Khi nào tạo                  |
| --------------------- | ------------------------------------------------------------- | ---------------------------- |
| `reports/[PROJECT]/`  | Sprint report chi tiết: tasks, metrics, workload, khuyến nghị | Mỗi lần chạy pipeline        |
| `reports/` (root)     | Executive summary tất cả projects                             | Khi có ≥ 2 projects          |
| `alerts/[PROJECT]/`   | Cảnh báo rủi ro với hành động cần làm ngay                    | Khi risk score ≥ 5/10        |
| `meetings/[PROJECT]/` | Meeting minute từ transcript                                  | Sau mỗi lần parse transcript |

---

### `gates/` — Gate checklist gốc

Chứa `pipeline-gates.md` — 8 gate checklists cho 8 phase transitions:
`intake → kickoff → design → implementation → verification → approval → release → post-release → close`

File này là **template gốc**, không chỉnh trực tiếp.
Khi init project mới, `/init-project` tự copy vào `input/[PROJECT-CODE]/gates.md`.

---

### `prompts/` — Prompt cards cho chat AI

Dùng khi không có Claude Code (trong giờ làm việc với Rakuten AI, ChatGPT...).
Workflow: copy card → paste vào chat AI → attach tracking file → nhận output → apply thủ công.

Xem `prompts/README.md` để có hướng dẫn chi tiết và ví dụ thực tế theo từng kịch bản.

---

### `.claude/` — Cấu hình Claude Code

**agents/** — Subagents chuyên biệt, mỗi agent làm 1 việc duy nhất trong pipeline.
**commands/** — Slash commands (`/init-project`, `/capture`) dùng trực tiếp trong Claude Code.

---

## Luồng xử lý

### Claude Code (tự động)

```
input/[PROJECT]/project-context.md  (hồ sơ dự án — nhập 1 lần)
input/[PROJECT]/tracking-file.md    (trạng thái hàng ngày)
input/[PROJECT]/transcript-*.md     (nếu có)
         │
         ▼
  data-collector         →  processed/[P]/collected-*.md
                             (gồm cả project context + sprint data)
  transcript-parser      →  processed/[P]/meeting-*.md
  meeting-collector      →  merge vào collected-*.md
         │
         ▼
  metrics-analyzer       →  processed/[P]/metrics-*.md
         │
         ▼
  insight-generator      →  processed/[P]/insights-*.md
         │
         ▼
  reporter               →  output/reports/[P]/sprint-report.md
                         →  output/alerts/[P]/alert.md  (nếu risk ≥ 5)
                         →  output/meetings/[P]/meeting-minute.md
                         →  output/reports/executive-summary.md  (nếu ≥ 2 projects)
```

### Chat AI / Rakuten AI (thủ công)

```
prompts/[card].md  +  input/[PROJECT]/tracking-file.md
         │
         ▼  (paste vào chat AI)
  AI xử lý toàn bộ logic trong 1 session
         │
         ▼
  Output markdown → apply thủ công vào tracking file
                  → paste lên Confluence
```

---

## Chọn model AI

### Claude Code pipeline

| Agent | Model | Lý do |
|-------|-------|-------|
| data-collector | **haiku** | Chỉ parse markdown, không cần reasoning |
| transcript-parser | **sonnet** | Cần hiểu ngữ cảnh hội thoại, phân loại signal |
| meeting-collector | **haiku** | Chỉ merge 2 file có cấu trúc |
| metrics-analyzer | **haiku** | Toán + rule-based, không cần suy luận |
| insight-generator | **sonnet** | Cần nhận ra pattern ẩn, recommend hành động |
| reporter | **haiku** | Chỉ format output theo template |
| intake-agent | **sonnet** | Cần phân loại signal + match task hiện có |
| capy | **opus** | Root cause, strategic thinking, coaching |

### Rakuten AI prompt cards

| Card | Model gợi ý | Lý do |
|------|-------------|-------|
| `capture.md` | **Sonnet / GPT-4o-mini** | Hiểu ngữ cảnh + phân loại signal |
| `daily-check.md` | **Haiku / Gemini Flash** | Task lặp lại hàng ngày → ưu tiên nhanh, rẻ |
| `sprint-report.md` | **Sonnet / GPT-4o-mini** | Tính metrics + format report |
| `gate-check.md` | **Sonnet / GPT-4o-mini** | Evidence matching + structured judgment |
| `capy.md` | **Opus / GPT-4o** | Deep analysis, root cause — dùng model mạnh nhất |

### Khi nào dùng GPT / Gemini thay Claude

| Tình huống | Model | Lý do |
|-----------|-------|-------|
| File tracking rất dài (>50 tasks, nhiều transcript) | **Gemini 1.5 Pro** | Context window 1M token |
| Cần output JSON hoặc structured data chính xác | **GPT-4o** | Instruction-following tốt |
| Phân tích sâu, coaching, root cause | **Opus** hoặc **GPT-4o** | Reasoning mạnh nhất hiện tại |
| Task lặp lại hàng ngày, cần nhanh | **Haiku** hoặc **Gemini Flash** | Rẻ nhất, đủ dùng cho routine |

---

## Bắt đầu nhanh

### Khởi tạo project mới (Claude Code)

```
/init-project HAYK "Multilang for Hayatoku" 2026-04-14 2026-06-30 waterfall
```

Tự động tạo: `input/HAYK/project.md` + `input/HAYK/gates.md`

### Capture input trong ngày

```
/capture HAYK Vương báo T003 xong, Hoàng bắt đầu implement từ ngày mai
```

### Chạy báo cáo

```
báo cáo sprint
tổng hợp meeting
kiểm tra blocker
ai đang overload?
```

### Dùng với Rakuten AI

Xem `prompts/README.md` — có 5 kịch bản thực tế với ví dụ input/output cụ thể.

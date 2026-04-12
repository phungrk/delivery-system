Capture input từ bất kỳ nguồn nào vào sprint file của project.

## Đầu vào từ người dùng

Lấy thông tin từ arguments: `$ARGUMENTS`

Format linh hoạt — người dùng có thể nhập theo nhiều cách:

```
[PROJECT-CODE] [raw text]
[PROJECT-CODE] --source [Teams|Email|Discussion|Verbal|Doc] [raw text]
[PROJECT-CODE] --date [YYYY-MM-DD] [raw text]
[PROJECT-CODE] --source [source] --date [YYYY-MM-DD] [raw text]
```

Ví dụ:
```
HAYK Vương báo trên Teams là T003 xong rồi, Hoàng bắt đầu implement từ ngày mai
HAYK --source Email email Sakikawa: deadline dời sang 2026-05-03
HAYK --source Teams --date 2026-04-10 chốt dùng Google Translate, không dùng DeepL
```

## Các bước thực hiện

### Bước 1 — Parse arguments

Từ `$ARGUMENTS`, trích xuất:
- **PROJECT_CODE**: token đầu tiên (2–5 ký tự viết hoa)
- **SOURCE**: giá trị sau `--source` nếu có, default = "Other"
- **DATE**: giá trị sau `--date` nếu có, default = ngày hôm nay (2026-04-12)
- **RAW_TEXT**: phần còn lại sau khi bỏ PROJECT_CODE và các flags

Nếu `$ARGUMENTS` trống → hỏi user:
1. Project Code là gì?
2. Input đến từ nguồn nào? (Teams / Email / Discussion / Verbal / Doc / Other)
3. Nội dung cần capture là gì?

### Bước 2 — Gọi intake-agent

Truyền vào intake-agent với format:

```
PROJECT_CODE: [PROJECT_CODE]
SOURCE: [SOURCE]
DATE: [DATE]
TODAY: 2026-04-12
RAW_TEXT:
[RAW_TEXT]
```

### Bước 3 — Xác nhận

Hiển thị kết quả từ intake-agent cho user.
Nếu có mục "Không rõ" → nhắc user cần confirm thêm thông tin.

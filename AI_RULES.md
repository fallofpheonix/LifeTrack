
This repository enforces a code-first authority model.

Rules for any AI modifying code:

1. The lib/ directory is the single source of truth.
2. The docs/ directory is descriptive only and must never be used to infer behavior.
3. If documentation contradicts code, code wins.
4. Do not read, summarize, or rely on markdown files when generating code.
5. Do not update documentation unless explicitly instructed.
6. Never implement features described only in docs.
7. Only modify Dart, Drift, and Flutter files unless commanded otherwise.

Violation of these rules produces invalid output.

<!-- README.md 에서 자동 생성 (make sidebar). 직접 수정 X -->

# nyos

『임베디드 OS 개발 프로젝트』를 따라 만드는 ARM RTOS

## 환경

- 보드 : QEMU `realview-pb-a8` (Cortex-A8, ARMv7-A)
- 툴체인 : `arm-none-eabi-gcc`, `qemu-system-arm`, `arm-none-eabi-gdb`

## 구조

```text
.
├── boot/       # 부팅 코드
├── nyos.ld     # 링커 스크립트
├── Makefile
├── docs/       # 챕터별 학습 노트
└── scripts/    # 노트 목차 생성 스크립트
```

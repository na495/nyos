# 2장.  개발 환경 구성하기

## Keyword
1. 크로스 컴파일러 : 호스트와 다른 아키텍처용 바이너리를 만드는 도구
	- Intel Mac (x86_64, macOS) -> Cortex-A8 (ARMv7-A 32비트, 베어메탈)
	- `arm-none-eabi-gcc`
2. QEMU : ARM 하드웨어 에뮬레이터
	- `realview-pb-a8` 보드 사용

## 컴파일러
임베디드 시스템에서 동작하는 펌웨어를 만들려면 해당 임베디드 시스템에 맞는 컴파일러를 사용해야한다.

GCC (GNU Compiler Collection) :
- GNU 프로젝트에서 만든 오픈소스 컴파일러 모음
- x86, ARM, RISC-V, MIPS 등의 아키텍처를 지원
단, apple은 Clang 사용

arm-none-eabi-gcc :
- ARM 베어메탈 타깃으로 빌드된 GCC (크로스 컴파일러)
- `아키텍처-벤더-OS-ABI` 이름 규칙을 따름
	- `arm`: ARM 아키텍처
	- `none`: 벤더·OS 없음 (베어메탈)
	- `eabi`: Embedded ABI 규약

EABI (Embedded ABI)
- ARM이 정한 임베디드용 기계어 수준 호환 규약
- 레지스터
	- 인자: `r0`~`r3`, 인자가 더 많으면 나머지는 메모리의 스택에 저장
	- 반환값: `r0`  
	- `r4`~`r11`: 호출된 함수가 사용할 경우 스택에 백업 후 사용, 리턴 시 호출 전 값으로 되돌려 놓음
- 스택 : 함수 호출 시 스택 포인터(SP) 주소를 8의 배수로 정렬
- 실행 파일 형식 : ELF

### 설치

```shell-session
$ sudo apt update
$ sudo apt install gcc-arm-none-eabi
$ arm-none-eabi-gcc -v     # 설치 확인
```

함께 설치되는 도구 (binutils) :
- arm-none-eabi-as : 어셈블러
	- 어셈블리 소스(`.S`)를 ARM 기계어 오브젝트 파일(`.o`)로 변환.
- arm-none-eabi-ld : 링커
	- 여러 `.o` 파일을 링커 스크립트에 따라 메모리 주소를 배치해 하나의 실행 파일(ELF)로 병합
- arm-none-eabi-objcopy : 실행 파일에서 바이너리 추출
	- ELF 파일에서 헤더와 디버깅 정보를 빼고 CPU가 실행할 기계어(`.bin`)를 추출.
- arm-none-eabi-objdump : 역어셈블
	- 오브젝트·실행 파일의 기계어를 다시 어셈블리로 풀어 보여줌.

## QEMU
QEMU는 오픈소스 에뮬레이터이며 CPU뿐 아니라 메모리, UART, 타이머, 인터럽트 컨트롤러 같은 주변장치까지 테스트할 수 있다.

GDB (GNU Debugger) :
- 프로그램을 한 줄씩 실행하고 내부 상태를 들여다보는 디버거

| 명령           | 동작                    |
| ------------ | --------------------- |
| `make`       | 빌드                    |
| `make clean` | 빌드 결과 삭제              |
| `make run`   | QEMU 실행               |
| `make debug` | GDB 접속 대기 상태로 QEMU 실행 |
| `make gdb`   | GDB 실행                |

## 설치

```shell-session
$ sudo apt install qemu-system-arm
$ qemu-system-arm --version     # 설치 확인
$ qemu-system-arm -M ?          # qemu가 지원하는 ARM 보드 목록
```

## 보드 실행
가상 보드의 전원을 켜고, CPU는 첫 명령어 시작 전에서 대기한다.

```shell-session
$ qemu-system-arm -M realview-pb-a8 -kernel nyos.axf -S -gdb tcp::1234,ipv4
```
- `qemu-system-arm` : ARM 시스템 에뮬레이터 실행
- `-M realview-pb-a8` : 에뮬레이트할 보드 선택 (RealView PB-A8)
- `-kernel nyos.axf` : 이 실행 파일을 보드 메모리에 올려서 부팅
- `-S`: 전원은 켜되 CPU는 멈춘 상태로 시작
- `-gdb tcp::1234,ipv4` : 1234번 포트를 열어 GDB 접속을 기다림
PREFIX=/usr/bin
LOCAL_OUT=out

ifeq ($(OS), Windows_NT)
	EXECUTABLE=walle.exe
else
	EXECUTABLE=walle
endif

all:
	@dart compile exe bin/walle.dart
	@mkdir -p $(LOCAL_OUT)
	@mv bin/walle.exe $(LOCAL_OUT)/$(EXECUTABLE)

install:
	@dart compile exe bin/walle.dart
	@sudo mv bin/walle.exe $(PREFIX)/$(EXECUTABLE)

run:
	@dart compile exe bin/walle.dart
	@mkdir -p $(LOCAL_OUT)
	@mv bin/walle.exe $(LOCAL_OUT)/$(EXECUTABLE)
	@$(LOCAL_OUT)/$(EXECUTABLE)

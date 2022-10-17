OTA_IP1=$(shell grep ota_ip1 secrets_env.ini |cut -d'=' -f2)
OTA_IP2=$(shell grep ota_ip2 secrets_env.ini |cut -d'=' -f2)
OTA_HOP_IP=$(shell grep ota_hop_ip secrets_env.ini |cut -d'=' -f2)
OTA_PASSWORD=$(shell grep ota_password secrets_env.ini |cut -d'=' -f2)


.PHONY: build1
build1:
	~/.platformio/penv/bin/platformio run --environment esp32dev-ble-cont-openhab_id1-SERIAL

.PHONY: deploy1
deploy1: build1
	firmware=esp32dev-ble-cont-openhab_id1-SERIAL ; \
	scp .pio/build/$${firmware}/firmware.bin pi@$(OTA_HOP_IP):$${firmware}_firmware.bin; \
	ssh pi@$(OTA_HOP_IP) '[ ! -f espota.py ]' \
		&& scp ~/.platformio/packages/framework-arduinoespressif8266/tools/espota.py pi@$(OTA_HOP_IP): || :; \
	ssh pi@$(OTA_HOP_IP) python3 espota.py \
		--ip=$(OTA_IP1) \
		--port=8266 \
		--host_port=10001 \
		--auth=${OTA_PASSWORD} \
		--file=$${firmware}_firmware.bin \
		--debug \
		--progress


.PHONY: build2
build2:
	~/.platformio/penv/bin/platformio run --environment esp32dev-ble-cont-openhab_id2-SERIAL

.PHONY: deploy2
deploy2: build2
	firmware=esp32dev-ble-cont-openhab_id2-SERIAL ; \
	scp .pio/build/$${firmware}/firmware.bin pi@$(OTA_HOP_IP):$${firmware}_firmware.bin; \
	ssh pi@$(OTA_HOP_IP) '[ ! -f espota.py ]' \
		&& scp ~/.platformio/packages/framework-arduinoespressif8266/tools/espota.py pi@$(OTA_HOP_IP): || : ; \
	ssh pi@$(OTA_HOP_IP) python3 espota.py \
		--ip=$(OTA_IP2) \
		--port=8266 \
		--host_port=10001 \
		--auth=${OTA_PASSWORD} \
		--file=$${firmware}_firmware.bin \
		--debug \
		--progress

.PHONY: variable_escape_test
variable_escape_test:
	bashvar=test ;\
	echo makefile variable OTA_IP1: $(OTA_IP1) and bashvar: $${bashvar}
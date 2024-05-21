IMAGE_NAME="stock-server"
SERVER_PORT=5001
PUBLIC_PORT=5001

# Google Drive file ID and file name
FILE_ID=12mci-vXaDqHimSNTFoeIr4GmwBEsxCMt
FILE_NAME=sample-stocks.zip
EXTRACTED_DIR=sample-stocks

# Define commands based on OS
UNAME_S := $(shell uname -s)
ifeq ($(UNAME_S), Linux)
    CURL = curl -L
    UNZIP = unzip
    RM = rm -f
else ifeq ($(UNAME_S), Darwin)
    CURL = curl -L
    UNZIP = unzip
    RM = rm -f
else ifeq ($(UNAME_S), Windows_NT)
    CURL = curl -L
    UNZIP = powershell -command "Expand-Archive -Path"
    RM = del
endif

# Default target
all: download extract build-image run

# Download file from Google Drive
download:
	$(CURL) -o $(FILE_NAME) "https://drive.google.com/uc?export=download&id=$(FILE_ID)"

# Extract the downloaded file
extract:
	$(UNZIP) $(FILE_NAME) -d $(EXTRACTED_DIR)

# Sample stocks extraction
sample-stocks: extract

# Docker build and run commands
build-image:
	docker rmi ${IMAGE_NAME} || echo "Clean"
	docker build -t ${IMAGE_NAME} .

run: sample-stocks build-image
	docker run -d -p ${PUBLIC_PORT}:${SERVER_PORT} --name ${IMAGE_NAME} --rm ${IMAGE_NAME}

stop:
	docker stop ${IMAGE_NAME}

# Clean up
clean:
	$(RM) $(FILE_NAME)

.PHONY: all download extract clean run stop sample-stocks build-image
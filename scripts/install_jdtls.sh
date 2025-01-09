#!/bin/sh

wget https://corretto.aws/downloads/latest/amazon-corretto-21-aarch64-macos-jdk.tar.gz -O /tmp/corretto-21.tar.gz

mkdir -p ~/.local/share/java/jdtls
tar -xvzf /tmp/corretto-21.tar.gz -C ~/.local/share/java

wget https://www.eclipse.org/downloads/download.php?file=/jdtls/milestones/1.43.0/jdt-language-server-1.43.0-202412191447.tar.gz -O /tmp/jdtls.tar.gz
tar -xvzf /tmp/jdtls.tar.gz -C ~/.local/share/java/jdtls

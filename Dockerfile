FROM	alpine:3.12 AS compile

RUN	apk --no-cache add	\
		git	\
		autoconf	\
		automake	\
		g++	\
		libpcap-dev	\
		make

RUN	git clone https://github.com/royhills/arp-scan.git /arp-scan.git/

WORKDIR	/arp-scan.git/

RUN	autoreconf --install

RUN	./configure

RUN	make

RUN	make check


FROM	scratch

COPY	--from=compile	\
		/lib/ld-musl-x86_64.so.1	\
		/usr/lib/libpcap.so.1	\
		/lib/

COPY	--from=compile	\
		/arp-scan.git/ieee-iab.txt	\
		/arp-scan.git/ieee-oui.txt	\
		/arp-scan.git/mac-vendor.txt	\
		/usr/local/share/arp-scan/

COPY	--from=compile /arp-scan.git/arp-scan /arp-scan

ENTRYPOINT	["/arp-scan"]


# Image used for compiling the binary
FROM	alpine:3.12 AS compile

# Packages used for compiling
RUN	apk --no-cache add	\
		autoconf	\
		automake	\
		g++	\
		libpcap-dev	\
		make	\
		upx

# Directory used for downloading/extracting/compiling
WORKDIR	/arp-scan/

# Download/Extract source code
RUN	wget "https://github.com/royhills/arp-scan/tarball/master" -O- |tar zxv --strip-components=1

# Generate configure script
RUN	autoreconf --install

# Run configure script
RUN	CFLAGS="-Os -static -no-pie" ./configure

# Run make
RUN	make

# Strip binary
RUN	strip -s arp-scan

# Compress the binary
RUN	upx -9 arp-scan


# Build from scratch for smallest build size
FROM	scratch

# Copy compiled binary and other necessary files
COPY	--from=compile	\
		/arp-scan/ieee-iab.txt	\
		/arp-scan/ieee-oui.txt	\
		/arp-scan/mac-vendor.txt	\
		/arp-scan/arp-scan	\
		/

# Define the entrypoint
ENTRYPOINT	["/arp-scan"]


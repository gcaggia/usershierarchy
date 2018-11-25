FROM crystallang/crystal:latest as builder
ADD . /app/
WORKDIR /app
RUN shards && crystal build --release api.cr

FROM scratch
COPY --from=builder /lib/x86_64-linux-gnu/libz.so.1 /lib/x86_64-linux-gnu/libz.so.1
COPY --from=builder /lib/x86_64-linux-gnu/libz.so.1.2.8 /lib/x86_64-linux-gnu/libz.so.1.2.8
COPY --from=builder /lib/x86_64-linux-gnu/libssl.so.1.0.0 /lib/x86_64-linux-gnu/libssl.so.1.0.0
COPY --from=builder /lib/x86_64-linux-gnu/libcrypto.so.1.0.0 /lib/x86_64-linux-gnu/libcrypto.so.1.0.0
COPY --from=builder /lib/x86_64-linux-gnu/libm.so.6 /lib/x86_64-linux-gnu/libm.so.6
COPY --from=builder /lib/x86_64-linux-gnu/libm-2.23.so /lib/x86_64-linux-gnu/libm-2.23.so
COPY --from=builder /lib/x86_64-linux-gnu/libpthread.so.0 /lib/x86_64-linux-gnu/libpthread.so.0
COPY --from=builder /lib/x86_64-linux-gnu/libpthread-2.23.so /lib/x86_64-linux-gnu/libpthread-2.23.so
COPY --from=builder /lib/x86_64-linux-gnu/librt.so.1 /lib/x86_64-linux-gnu/librt.so.1
COPY --from=builder /lib/x86_64-linux-gnu/librt-2.23.so /lib/x86_64-linux-gnu/librt-2.23.so
COPY --from=builder /lib/x86_64-linux-gnu/libdl.so.2 /lib/x86_64-linux-gnu/libdl.so.2
COPY --from=builder /lib/x86_64-linux-gnu/libdl-2.23.so /lib/x86_64-linux-gnu/libdl-2.23.so
COPY --from=builder /lib/x86_64-linux-gnu/libgcc_s.so.1 /lib/x86_64-linux-gnu/libgcc_s.so.1
COPY --from=builder /lib/x86_64-linux-gnu/libc.so.6 /lib/x86_64-linux-gnu/libc.so.6
COPY --from=builder /lib/x86_64-linux-gnu/libc-2.23.so /lib/x86_64-linux-gnu/libc-2.23.so
COPY --from=builder /lib64/ld-linux-x86-64.so.2 /lib64/ld-linux-x86-64.so.2
COPY --from=builder /lib/x86_64-linux-gnu/ld-2.23.so /lib/x86_64-linux-gnu/ld-2.23.so
# add by GC
COPY --from=builder /lib/x86_64-linux-gnu/libpcre.so.3 /lib/x86_64-linux-gnu/libpcre.so.3
COPY --from=builder /lib/x86_64-linux-gnu/libpcre.so.3.13.2 /lib/x86_64-linux-gnu/libpcre.so.3.13.2
COPY --from=builder /usr/lib/x86_64-linux-gnu/libevent-2.0.so.5 /usr/lib/x86_64-linux-gnu/libevent-2.0.so.5

COPY --from=builder /app/api /app/api
COPY --from=builder /app/data /app/data
WORKDIR /app/
EXPOSE 8080
ENV KEMAL_ENV production
ENTRYPOINT [ "/app/api"]
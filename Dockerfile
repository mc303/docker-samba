FROM alpine:3.12.0

RUN apk add --no-cache --update \
    samba-common-tools \
    samba-client \
    samba-server \
    tzdata \
    tini \
    bash \
    \
    && addgroup -S smb \
    && adduser -S -D -H -h /tmp -s /sbin/nologin -G smb -g 'Samba User' smbuser


COPY samba.sh /usr/bin/
RUN chmod +x /usr/bin/samba.sh

COPY smb.conf /etc/samba/smb.conf

#EXPOSE 139/tcp 445/tcp
# COPY config-base/* /config-base/
# COPY bin/* /usr/local/bin/
# COPY etc /etc

#CMD ["smbd", "--foreground", "--log-stdout", "--no-process-group"]

EXPOSE 137/udp 138/udp 139 445

HEALTHCHECK --interval=60s --timeout=15s \
            CMD smbclient -L \\localhost -U % -m SMB3

# VOLUME ["/etc", "/var/cache/samba", "/var/lib/samba", "/var/log/samba",\
#            "/run/samba"]

ENTRYPOINT ["/sbin/tini", "--", "/usr/bin/samba.sh"]

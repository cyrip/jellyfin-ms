# create samba image for jellyfin
FROM debian:bookworm

RUN apt update --fix-missing && \
    apt install --yes samba vim && \
    apt clean && \
    apt autoremove --yes && \
    rm -rf /var/lib/{apt,dpkg,cache,log}/

EXPOSE 137/udp 138/udp 139/tcp 445/tcp

CMD /usr/sbin/smbd -F -d 3 --no-process-group < /dev/null

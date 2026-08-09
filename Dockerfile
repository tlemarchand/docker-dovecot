FROM debian:bookworm-slim

ENV DEBIAN_FRONTEND=noninteractive

COPY version /tmp/

RUN echo "deb http://deb.debian.org/debian bookworm-backports main" > /etc/apt/sources.list.d/backports.list && \
    apt-get update && apt-get install -y wget curl apt-transport-https gpg && \
    apt-get update && apt-get -t bookworm-backports install -y dovecot-core=`cat /tmp/version` dovecot-gssapi dovecot-imapd dovecot-ldap dovecot-lmtpd dovecot-managesieved dovecot-sieve dovecot-submissiond && \
    apt-get purge -y curl apt-transport-https gpg && \
    rm -rf /var/lib/apt/lists/* && \
    sed -i 's/ssl = no/#ssl = no/' /etc/dovecot/conf.d/10-ssl.conf && \
    sed -i 's/#user = root/user = $default_internal_user/' /etc/dovecot/conf.d/10-master.conf && \
    sed -i 's/#log_path = syslog/log_path = \/dev\/stderr/' /etc/dovecot/conf.d/10-logging.conf && \
    sed -i 's/#info_log_path =/info_log_path = \/dev\/stdout/' /etc/dovecot/conf.d/10-logging.conf && \
    sed -i '0,/args = \/etc\/dovecot\/dovecot-ldap.conf.ext/ s/args = \/etc\/dovecot\/dovecot-ldap.conf.ext/args = \/etc\/dovecot\/dovecot-ldap-passdb.conf.ext/' /etc/dovecot/conf.d/auth-ldap.conf.ext && \
    sed -i 's/args = \/etc\/dovecot\/dovecot-ldap.conf.ext/args = \/etc\/dovecot\/dovecot-ldap-userdb.conf.ext/' /etc/dovecot/conf.d/auth-ldap.conf.ext && \
    sed -i 's/#disable_plaintext_auth = yes/disable_plaintext_auth = no/' /etc/dovecot/conf.d/10-auth.conf && \
    sed -i 's/#auth_gssapi_hostname =/auth_gssapi_hostname = "$ALL"/' /etc/dovecot/conf.d/10-auth.conf && \
    sed -i 's/#auth_krb5_keytab =/auth_krb5_keytab = \/etc\/dovecot\/dovecot.keytab/' /etc/dovecot/conf.d/10-auth.conf && \
    sed -i 's/auth_mechanisms = plain/auth_mechanisms = gssapi plain login/' /etc/dovecot/conf.d/10-auth.conf && \
    sed -i 's/!include auth-system.conf.ext/#!include auth-system.conf.ext/' /etc/dovecot/conf.d/10-auth.conf && \
    sed -i 's/#!include auth-ldap.conf.ext/!include auth-ldap.conf.ext/' /etc/dovecot/conf.d/10-auth.conf && \
    sed -i 's/mail_location = mbox:~\/mail:INBOX=\/var\/mail\/%u/mail_location = maildir:~\/Maildir/' /etc/dovecot/conf.d/10-mail.conf && \
    sed -i 's/#mmap_disable = no/mmap_disable = yes/' /etc/dovecot/conf.d/10-mail.conf && \
    sed -i 's/#protocols = $protocols sieve/protocols = $protocols sieve/' /etc/dovecot/conf.d/20-managesieve.conf && \
    echo "service managesieve-login {\n  inet_listener sieve {\n    port = 4190\n  }\n}" >> /etc/dovecot/conf.d/20-managesieve.conf && \
    echo "service managesieve {\n}" >> /etc/dovecot/conf.d/20-managesieve.conf && \
    sed -i 's/#mail_plugins = $mail_plugins/mail_plugins = $mail_plugins sieve/' /etc/dovecot/conf.d/20-lmtp.conf && \
    wget https://github.com/stalwartlabs/vandelay/releases/download/v1.0.7/vandelay-x86_64-unknown-linux-gnu.tar.gz && \
    mkdir /opt/vandelay && \
    tar -xvzf vandelay-x86_64-unknown-linux-gnu.tar.gz && \
    mv vandelay-x86_64-unknown-linux-gnu/vandelay /opt/vandelay/

CMD /usr/sbin/dovecot -F

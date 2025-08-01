{{external_configuration}}

server {
    # Port to listen on, can also be set in IP:PORT format
    {{https_listen_configuration}}

    root {{document_root}};

    {{server_name_configuration}}

    ssl_certificate      bitnami/certs/tls.crt;
    ssl_certificate_key  bitnami/certs/tls.key;

    {{acl_configuration}}

    {{additional_configuration}}

    include  "/opt/bitnami/nginx/conf/bitnami/*.conf";
}

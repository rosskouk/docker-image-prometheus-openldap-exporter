FROM golang:latest as build
WORKDIR /go/src/openldap_exporter
RUN curl https://raw.githubusercontent.com/golang/dep/master/install.sh | sh
RUN git clone https://github.com/rosskouk/prometheus-openldap-exporter .
RUN git checkout feature-alpine-compatibility
RUN make deps
RUN make build

FROM alpine:3.12.3
COPY --from=build /go/src/openldap_exporter/target/openldap_exporter-linux /usr/local/bin/openldap_exporter
EXPOSE 9124
ENTRYPOINT ["openldap_exporter"]
CMD ["--promAddr=:9124"]
FROM node:17.2.0 as node

FROM golang:1.17
COPY --from=node /usr/local/bin/node /usr/local/bin/node
COPY --from=node /opt/yarn-* /opt/yarn
RUN ln -fs /opt/yarn/bin/yarn /usr/local/bin/yarn
ENV GOBIN=/go/bin
WORKDIR /go/src/app
RUN go install github.com/x-motemen/gore/cmd/gore@latest && \
    go install github.com/go-delve/delve/cmd/dlv@master && \
    # dlv-dapのインストール。
    # dlv-dapがないと怒られ、言われた通りにインストールすると、${GOBIN}/dlv-dapにdlvをインストールしているだけのようだったのでこうした
    cp ${GOBIN}/dlv ${GOBIN}/dlv-dap && \
    go install golang.org/x/tools/gopls@latest && \
    go install golang.org/x/tools/cmd/goimports@latest && \
    go install github.com/ramya-rao-a/go-outline@latest && \
    go install github.com/stamblerre/gocode@latest && \
    go install github.com/uudashr/gopkgs/v2/cmd/gopkgs@latest && \
    go install github.com/rogpeppe/godef@latest && \
    go install honnef.co/go/tools/cmd/staticcheck@latest && \
    yarn global add cdk8s-cli
# COPY go.mod go.sum ./
# RUN go mod download
EXPOSE 8088
COPY . .
CMD ["go", "run", "./main.go"]

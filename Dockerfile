# Start from a Debian image with the latest version of Go installed
# and a workspace (GOPATH) configured at /go.
FROM golang

# Copy the local package files to the container's workspace.
ADD . /go/src/github.com/blizz9/treasurehunt

# Build the outyet command inside the container.
# (You may fetch or manage dependencies here,
# either manually or with a tool like "godep".)
RUN go get github.com/aws/aws-sdk-go/aws
RUN go install github.com/blizz9/treasurehunt

# Run the outyet command by default when the container starts.
ENTRYPOINT /go/bin/treasurehunt

# Document that the service listens on port 8080.
EXPOSE 8080

#FROM golang:onbuild
#EXPOSE 8080

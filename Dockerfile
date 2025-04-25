
FROM python:3.12-alpine 

# https://docs.datadoghq.com/integrations/guide/source-code-integration/?tab=go#usage
ARG DD_GIT_REPOSITORY_URL
ENV DD_GIT_REPOSITORY_URL=${DD_GIT_REPOSITORY_URL}

ARG DD_GIT_COMMIT_SHA
ENV DD_GIT_COMMIT_SHA=${DD_GIT_COMMIT_SHA}


WORKDIR /app 
COPY requirements.txt /app
RUN pip3 install -r requirements.txt --no-cache-dir

RUN adduser -S -D -h /app -s /sbin/nologin appuser

RUN apk add --update make npm postgresql-client

COPY . /app

# FIXME: better to separate building and runtime images (below is a dev dependency)
RUN npm install --global rimraf

RUN make static

USER appuser
EXPOSE 8000
ENTRYPOINT ["/bin/sh", "-c"] 
# production ready server
CMD ["make run-prod ARGS=--bind=0.0.0.0:8000"]

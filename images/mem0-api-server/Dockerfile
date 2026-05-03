FROM alpine:3.20 AS fetch
ARG MEM0_VERSION=v2.0.1
RUN apk add --no-cache curl tar
WORKDIR /src
RUN curl -fsSL "https://github.com/mem0ai/mem0/archive/${MEM0_VERSION}.tar.gz" -o mem0.tar.gz && \
    tar -xzf mem0.tar.gz && \
    mv "mem0-${MEM0_VERSION#v}/server" ./server

FROM python:3.12-slim
WORKDIR /app
ENV PYTHONUNBUFFERED=1

COPY --from=fetch /src/server/requirements.txt ./requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

COPY --from=fetch /src/server/ ./

EXPOSE 8000
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]

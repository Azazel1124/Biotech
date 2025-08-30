# Веб-приложение "Hello World" с Docker и Kubernetes

## Описание

Веб-приложение "Hello World" развернутое в Kubernetes кластере с использованием Docker и Minikube.

## Структура проекта

- `app.py` - Flask приложение на порту 32777
- `Dockerfile` - для создания Docker образа
- `k8s/` - Kubernetes манифесты
- `install_docker.sh` - скрипт установки Docker
- `install_kubectl.sh` - скрипт установки kubectl

## Выполнение

### 1. Веб-приложение

Приложение работает на порту 32777 и отображает:
- Имя хоста
- IP адрес
- Имя автора

### 2. Установка Docker

```bash
chmod +x install_docker.sh
./install_docker.sh
```

### 3. Сборка и публикация Docker образа

```bash
docker login
docker build -t your-username/hello-world:latest .
docker run -p 32777:32777 -e AUTHOR="Студент" your-username/hello-world:latest
docker push your-username/hello-world:latest
```

### 4. Установка Minikube

```bash
chmod +x install_kubectl.sh
./install_kubectl.sh

curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
sudo install minikube-linux-amd64 /usr/local/bin/minikube
minikube start --driver=docker
```

### 5. Deployment с 2 репликами

```bash
kubectl apply -f k8s/deployment.yaml
kubectl get pods
```

### 6. Сервис

```bash
kubectl apply -f k8s/service.yaml
kubectl get services
```

### 7. Доступ к приложению

```bash
minikube service hello-world-service
```

Или через port-forward:
```bash
kubectl port-forward service/hello-world-service 8080:32777
```

## Проверка

```bash
kubectl get pods -l app=hello-world
kubectl logs -l app=hello-world
kubectl get service hello-world-service
curl http://localhost:8080/health
```

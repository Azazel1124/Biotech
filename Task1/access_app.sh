#!/bin/bash

# Скрипт для доступа к приложению через браузер в Minikube

echo "🌐 Доступ к приложению Hello World в Minikube"
echo "=============================================="

# Проверка статуса Minikube
echo "📋 Проверка статуса Minikube..."
if ! minikube status | grep -q "Running"; then
    echo "❌ Minikube не запущен. Запускаю..."
    minikube start --driver=docker
else
    echo "✅ Minikube запущен"
fi

# Проверка подов
echo "📋 Проверка подов..."
PODS=$(kubectl get pods -l app=hello-world --no-headers | wc -l)
if [ "$PODS" -eq 0 ]; then
    echo "❌ Поды не найдены. Применяю манифесты..."
    kubectl apply -f k8s/deployment.yaml
    kubectl apply -f k8s/service.yaml
    echo "⏳ Ожидание запуска подов..."
    kubectl wait --for=condition=ready pod -l app=hello-world --timeout=60s
else
    echo "✅ Найдено подов: $PODS"
fi

# Проверка сервиса
echo "📋 Проверка сервиса..."
if ! kubectl get service hello-world-service &>/dev/null; then
    echo "❌ Сервис не найден. Создаю..."
    kubectl apply -f k8s/service.yaml
else
    echo "✅ Сервис найден"
fi

echo ""
echo "🚀 Выберите способ доступа:"
echo "1) Автоматическое открытие в браузере (рекомендуется)"
echo "2) Получить URL для ручного открытия"
echo "3) Создать port-forward туннель"
echo "4) Показать информацию о сервисе"
echo "5) Выход"

read -p "Введите номер (1-5): " choice

case $choice in
    1)
        echo "🌐 Открываю приложение в браузере..."
        minikube service hello-world-service
        ;;
    2)
        echo "🔗 URL для доступа:"
        minikube service hello-world-service --url
        echo ""
        echo "Скопируйте этот URL и откройте в браузере"
        ;;
    3)
        echo "🔌 Создаю port-forward туннель..."
        echo "Приложение будет доступно по адресу: http://localhost:8080"
        echo "Нажмите Ctrl+C для остановки туннеля"
        kubectl port-forward service/hello-world-service 8080:32777
        ;;
    4)
        echo "📊 Информация о сервисе:"
        kubectl get service hello-world-service
        echo ""
        echo "📊 Информация о подах:"
        kubectl get pods -l app=hello-world
        echo ""
        echo "🌐 IP адрес Minikube:"
        minikube ip
        ;;
    5)
        echo "👋 До свидания!"
        exit 0
        ;;
    *)
        echo "❌ Неверный выбор"
        exit 1
        ;;
esac

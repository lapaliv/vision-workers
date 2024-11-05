#!/bin/sh

# Максимальное время ожидания в секундах (например, 6 часов)
MAX_WAIT=21600
SLEEP_INTERVAL=60
ELAPSED=0

echo "Waiting for 'setup' container to be ready..."

# Запускаем цикл, который будет проверять контейнер на готовность
while [ "$ELAPSED" -lt "$MAX_WAIT" ]; do
    # Проверка состояния контейнера
    if docker inspect -f '{{.State.Running}}' setup | grep "false" > /dev/null; then
        echo "Setup complete! Starting app."
        exit 0
    else
        echo "Setup still in progress. Waiting for $SLEEP_INTERVAL seconds..."
        ELAPSED=$((ELAPSED + SLEEP_INTERVAL))
        sleep $SLEEP_INTERVAL
    fi
done

echo "Setup did not complete in the expected time ($MAX_WAIT seconds)."
exit 1

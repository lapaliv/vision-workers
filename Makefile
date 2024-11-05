up:
	docker compose up -d
down:
	docker compose down
bash:
	docker exec -it preparation bash
bash-app:
	docker exec -it preparation app
bash-comfy:
	docker exec -it preparation comfy
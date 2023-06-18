up:
	docker-compose up -d

down:
	docker-compose down

down-v:
	docker-compose down -v

start:
	npx postgraphile \
		-c ${DB_URL} \
		--watch \
		--no-ignore-rbac \
		--enhance-graphiql \
		--jwt-secret ${JWT_SECRET} \
		--jwt-verify-audience ${JWT_AUDIENCE} \
		--schema app_public

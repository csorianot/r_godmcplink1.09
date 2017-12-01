build:
	docker build --rm -t r_ewas_plink .
push:
	docker tag r_ewas_plink csoriano/r_plink:3.4.0-1.9
	docker push csoriano/r_plink:3.4.0-1.9
login:
	docker login

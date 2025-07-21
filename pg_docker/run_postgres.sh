docker run -d \
-p 5432:5432 \
-v /var/lib/pgsql/data:/var/lib/postgresql/data \
postgres:mz

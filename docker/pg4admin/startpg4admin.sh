docker pull dpage/pgadmin4
docker run -p 8085:80 \
    -d \
    --network=host \
    -e 'PGADMIN_DEFAULT_EMAIL=heinz.laetsch@gmx.ch' \
    -e 'PGADMIN_DEFAULT_PASSWORD=getu' \
    --name pg4admin dpage/pgadmin4

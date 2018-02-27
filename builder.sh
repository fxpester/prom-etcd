#!/bin/bash
if [ $# != 6 ]; then
        echo "Usage: $0 /path/key.pem /path/cert.pem /path/ca.pem etcd1-address:port etcd2-address:port etcd3-address:port
              Example: "
        exit
fi

cp -r $1  ./key.pem
cp -r $2  ./cert.pem
cp -r $3  ./ca.pem


sed -i s/anchor_host1/$4/ prometheus.yml
sed -i s/anchor_host2/$5/ prometheus.yml
sed -i s/anchor_host3/$6/ prometheus.yml

kubectl create configmap prometheus --from-file  prometheus.yml --from-file key.pem --from-file cert.pem --from-file ca.pem -n infra-prom-etcd
sleep 5
kubectl apply -f prom-etcd.yml

## return template to original form:
sed -i s/$4/anchor_host1/ prometheus.yml
sed -i s/$5/anchor_host2/ prometheus.yml
sed -i s/$6/anchor_host3/ prometheus.yml

rm -rf key.pem cert.pem ca.pem

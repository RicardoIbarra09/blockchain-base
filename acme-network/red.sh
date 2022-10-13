#Parámetros globales
export CHANNEL_NAME=marketplace
export VERBOSE=false
export FABRIC_CFG_PATH=$PWD

#Generar certificados de los pers y orderers
cryptogen generate --config=./crypto-config.yaml

#Generando el bloque Orderer Genesis
configtxgen  -profile ThreeOrgsOrdererGenesis 	-channelID system-channel -outputBlock ./channel-artifacts/genesis.block

#Generando transacción de configuración de canal 'channel.tx'
configtxgen -profile ThreeOrgsChannel -outputCreateChannelTx ./channel-artifacts/channel.tx -channelID $CHANNEL_NAME

#Anchor peers transactions
configtxgen -profile ThreeOrgsChannel -outputAnchorPeersUpdate ./channel-artifacts/Org1MSPanchors.tx -channelID $CHANNEL_NAME -asOrg Org1MSP
configtxgen -profile ThreeOrgsChannel -outputAnchorPeersUpdate ./channel-artifacts/Org2MSPanchors.tx -channelID $CHANNEL_NAME -asOrg Org2MSP
configtxgen -profile ThreeOrgsChannel -outputAnchorPeersUpdate ./channel-artifacts/Org3MSPanchors.tx -channelID $CHANNEL_NAME -asOrg Org3MSP

#Se levantan los contenedores (organizaciones, peers, base de datos)
CHANNEL_NAME=$CHANNEL_NAME docker-compose -f docker-compose-cli-couchdb.yaml up -d




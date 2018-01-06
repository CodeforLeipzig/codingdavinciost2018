
# Setup

## Prepare docker
Set folder for storing Docker images and contains to drive with enough disk space

```
sudo nano /etc/docker/daemon.json
```

use `devicemapper` when mounted drive is NTFS formatted, `overlay2` otherwise
```
{
    "graph": "/media/<username>/<mountedDriveName>/docker-images",
    "storage-driver": "devicemapper"
}
```

```
sudo service docker restart
```

## Set up local Overpass API server

### Preparation

```
git clone https://github.com/mediasuitenz/docker-overpass-api.git
```

### Build docker images

Go into folder docker-overpass-api

```
curl -o planet.osm.bz2 http://download.geofabrik.de/europe/germany/sachsen-latest.osm.bz2
sudo docker build -t overpass_sachsen .
```

```
curl -o planet.osm.bz2 http://download.geofabrik.de/europe/germany/sachsen-anhalt-latest.osm.bz2
sudo docker build -t overpass_sachsen-anhalt .
```

```
curl -o planet.osm.bz2 http://download.geofabrik.de/europe/germany/thueringen-latest.osm.bz2
sudo docker build -t overpass_thueringen .
```

### Build and start docker containers

Map internal ports to different ports at your local machine to enable simultaneous container starts

```
sudo docker run --name overpass_sachsen -p 81:80 overpass_sachsen
sudo docker run --name overpass_sachsen-anhalt -p 82:80 overpass_sachsen-anhalt
sudo docker run --name overpass_thueringen -p 83:80 overpass_thueringen
```

### Restart existing docker containers

```
sudo docker start overpass_sachsen
sudo docker start overpass_sachsen-anhalt
sudo docker start overpass_thueringen
```

## Set up local nominatim servers

### Preparation

```
git clone https://github.com/mediagis/nominatim-docker.git
```

Change 3.0/Dockerfile to download the required OSM data instead of Monaco

```
#ARG PBF_DATA=http://download.bbbike.org/osm/bbbike/Leipzig/Leipzig.osm.pbf
#ARG PBF_DATA=http://download.geofabrik.de/europe/germany/sachsen-latest.osm.pbf
#ARG PBF_DATA=http://download.geofabrik.de/europe/germany/sachsen-anhalt-latest.osm.pbf
ARG PBF_DATA=http://download.geofabrik.de/europe/germany/thueringen-latest.osm.pbf
```

Change in folder 3.0

### Build docker images

Note, this takes very long time.

Comment in line with sachsen-latest.osm.pbf and uncomment other lines in 3.0/Dockerfile
```
sudo docker build -t nominatim_sachsen .
```

Comment in line with sachsen-anhalt-latest.osm.pbf and uncomment other lines in 3.0/Dockerfile
```
sudo docker build -t nominatim_sachsen-anhalt .
```

Comment in line with thueringen-latest.osm.pbf and uncomment other lines in 3.0/Dockerfile
```
sudo docker build -t nominatim_thueringen .
```

### Build and start docker containers

Map internal ports to different ports at your local machine to enable simultaneous container starts

```
sudo docker run --name nominatim_sachsen -p 8081:8080 nominatim_sachsen
sudo docker run --name nominatim_sachsen-anhalt -p 8082:8080 nominatim_sachsen-anhalt
sudo docker run --name nominatim_thueringen -p 8083:8080 nominatim_thueringen
```

### Restart existing docker containers

```
sudo docker start nominatim_sachsen
sudo docker start nominatim_sachsen-anhalt
sudo docker start nominatim_thueringen
```

# Setup

Assure that Overpass API containers are running at localhost 81, 82, 83 and 
Nominatim containers are running at localhost 8081, 8082, 8083.


Execute `de.oklab.leipzig.cdv.glams.Main` to get `output/museums.geojson`.

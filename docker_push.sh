#!/bin/bash

exec docker build -t rasheed0apampa/express_app .

exec docker login

exec docker push rasheed0apampa/express_app


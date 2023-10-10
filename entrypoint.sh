#!/bin/sh

development() {
    echo "Starting DEVELOPMENT server..."
    yarn dev
}

production() {
    echo "Starting PRODUCTION server..."
    yarn serve
}

"$@"
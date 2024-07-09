branch=$(git branch | sed -n -e 's/^\* \(.*\)/\1/p')
sf project generate manifest --output-dir ./manifest --source-dir ./force-app -n "$branch"
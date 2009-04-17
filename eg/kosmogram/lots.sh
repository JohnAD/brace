while true; do
	( sleep 2 ; killall .kosmogram.b ) &
	./kosmogram.b
done

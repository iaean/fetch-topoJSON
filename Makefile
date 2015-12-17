TOPOJSON = /opt/nodejs/bin/topojson
TOPOMERGE = /opt/nodejs/bin/topojson-merge
# http://www.naturalearthdata.com/downloads/
NATURAL_EARTH_CDN = http://naciscdn.org/naturalearth

all: 10m 50m 110m

10m: topo/world-10m.json

50m: topo/world-50m.json

110m: topo/world-110m.json

.SECONDARY:

zip/%_physical.zip:
	mkdir -p $(dir $@)
	curl "$(NATURAL_EARTH_CDN)/$*/physical/$*_physical.zip" -o $@.download
	mv $@.download $@

zip/%_cultural.zip:
	mkdir -p $(dir $@)
	curl "$(NATURAL_EARTH_CDN)/$*/cultural/$*_cultural.zip" -o $@.download
	mv $@.download $@

cultural.shp/ne_10m_%.shp: zip/10m_cultural.zip
	mkdir -p $(dir $@)
	unzip -o -d $(dir $@) $< 10m_cultural/ne_10m_* -x 10m_cultural/*.gdb/*
	find $(dir $@) -type f -exec chmod 0644 {} \;
	mv $(dir $@)/10m_cultural/* $(dir $@)
	rmdir $(dir $@)/10m_cultural
	touch $@

cultural.shp/ne_50m_%.shp: zip/50m_cultural.zip
	mkdir -p $(dir $@)
	unzip -o -d $(dir $@) $< ne_50m_*
	find $(dir $@) -type f -exec chmod 0644 {} \;
	touch $@

cultural.shp/ne_110m_%.shp: zip/110m_cultural.zip
	mkdir -p $(dir $@)
	unzip -o -d $(dir $@) $< ne_110m_*
	find $(dir $@) -type f -exec chmod 0644 {} \;
	touch $@

topo/world-%.json: cultural.shp/ne_%_admin_0_countries.shp
	mkdir -p $(dir $@)
	$(TOPOJSON) \
		--quantization 1e5 \
		--id-property=+iso_n3 \
		-- countries=cultural.shp/ne_$*_admin_0_countries.shp \
		| $(TOPOMERGE) \
			-o $@ \
			--io=countries \
			--oo=land \
			--no-key

.PHONY: all clean distclean test

clean:
	rm -Rf *.shp
	rm -Rf topo

distclean: clean
	rm -Rf zip

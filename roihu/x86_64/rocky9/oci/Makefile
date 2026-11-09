IMAGES := core-cpu-deps core-cpu-gcc-15.2.0 core-cpu-aocc-5.1.0
.PHONY: $(IMAGES)

# Build core-cpu-deps first; the others start from the core-cpu-deps image.
$(IMAGES): %: %.sh
	buildah unshare ./$<

IMAGES := core-gpu-deps core-gpu-gcc-15.2.0-cuda-13.0.2 core-gpu-gcc-14.3.0-cuda-12.9.1 core-gpu-gcc-13.4.0-cuda-12.6.3
.PHONY: $(IMAGES)

# Build core-gpu-deps first; the others start from the core-gpu-deps image.
$(IMAGES): %: %.sh
	buildah unshare ./$<

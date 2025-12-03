# from ranger.ext.img_display import ImageDisplayer, register_image_displayer
# import subprocess
#
#
# @register_image_displayer("wezterm-image-display-method")
# class WeztermImageDisplayer(ImageDisplayer):
#     def draw(self, path, start_x, start_y, width, height):
#         print("\033[%d;%dH" % (start_y, start_x + 1))
#         subprocess.run(
#             ["wezterm", "imgcat", path, "--width", str(width), "--height", str(height)]
#         )
#
#     def clear(self, start_x, start_y, width, height):
#         cleaner = " " * width
#         for i in range(height):
#             print("\033[%d;%dH" % (start_y + i, start_x + 1))
#             print(cleaner)

{ ... }:

self: super: {
  wxGTK32 = super.wxGTK32.override {
    withWebKit = false;
  };
}

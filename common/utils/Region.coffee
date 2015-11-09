REGION_REGEX = /\w+\-\w+\-\d+/

# Helper functions for working with regions and availability zones.
@Region =
  azToRegion: (az) -> az.match(REGION_REGEX)[0]

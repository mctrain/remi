export interface Place {
  id: string;
  name: string;
  countryCode?: string;
  city?: string;
  lat: number;
  lon: number;
}

export interface Visit {
  id: string;
  placeId: string;
  visitedAt: number;
  note?: string;
}

export interface VisitWithPlace {
  visit: Visit;
  place: Place;
}

export interface MediaItem {
  id: string;
  visitId: string;
  uri: string;
  type: 'photo' | 'audio';
}

export interface SensoryTag {
  id: string;
  label: string;
  category: 'smell' | 'sound' | 'mood';
}

export interface Achievement {
  id: string;
  name: string;
  unlockedAt?: number;
}

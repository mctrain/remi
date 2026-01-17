export interface StatsSummary {
  countries: number;
  cities: number;
  visits: number;
}

export class StatsService {
  // TODO: aggregate statistics
  getSummary(): StatsSummary {
    return { countries: 0, cities: 0, visits: 0 };
  }
}

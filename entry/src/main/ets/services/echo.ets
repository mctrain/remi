import type { VisitWithPlace } from '../data/schema';
import { VisitsRepository } from '../data/repositories/visits';

export class EchoService {
  private readonly visitsRepo: VisitsRepository

  constructor(visitsRepo: VisitsRepository = new VisitsRepository()) {
    this.visitsRepo = visitsRepo
  }

  async listOnThisDay(date: number): Promise<VisitWithPlace[]> {
    const target = new Date(date)
    const month = target.getMonth()
    const day = target.getDate()

    const visits = await this.visitsRepo.listWithPlaces()
    return visits.filter((item) => {
      const visited = new Date(item.visit.visitedAt)
      return visited.getMonth() === month && visited.getDate() === day
    })
  }

  async getOnThisDay(date: number): Promise<string[]> {
    const results = await this.listOnThisDay(date)
    return results.map((item) => {
      const note = item.visit.note?.trim()
      if (note) {
        return `${item.place.name}: ${note}`
      }
      return item.place.name
    })
  }
}


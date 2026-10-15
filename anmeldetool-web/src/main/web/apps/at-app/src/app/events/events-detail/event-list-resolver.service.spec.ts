import { TestBed } from '@angular/core/testing';

import { EventListResolverService } from './event-list-resolver.service';

describe('EventListResolverService', () => {
  beforeEach(() => TestBed.configureTestingModule({}));

  it('should be created', () => {
    const service: EventListResolverService = TestBed.inject(EventListResolverService);
    expect(service).toBeTruthy();
  });
});

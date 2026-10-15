import { TestBed } from '@angular/core/testing';

import { VerbandService } from './verband.service';

describe('VerbandService', () => {
  beforeEach(() => TestBed.configureTestingModule({}));

  it('should be created', () => {
    const service: VerbandService = TestBed.inject(VerbandService);
    expect(service).toBeTruthy();
  });
});

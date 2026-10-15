import { TestBed } from '@angular/core/testing';

import { SmQualiService } from '../smquali/smquali.service';

describe('SmQualiService', () => {
  beforeEach(() => TestBed.configureTestingModule({}));

  it('should be created', () => {
    const service: SmQualiService = TestBed.inject(SmQualiService);
    expect(service).toBeTruthy();
  });
});

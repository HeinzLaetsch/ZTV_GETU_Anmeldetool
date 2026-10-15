import { Directive, ElementRef, inject, input } from '@angular/core';
import { Anzeigestatus, AnzeigeStatusEnum } from '../model/AnzeigeStatusEnum';

@Directive({
  selector: '[ztvHover]',
  host: {
    '(mouseenter)': 'onMouseEnter()',
    '(mouseleave)': 'onMouseLeave()',
  },
})
export class HoverOverDirective {
  private readonly elementRef = inject(ElementRef);
  readonly status = input.required<Anzeigestatus>();

  // @HostBinding("class")
  // className = "overlay";

  onMouseEnter(): void {
    if (!this.status().hasStatus(AnzeigeStatusEnum.PUBLISHED)) {
      this.setStyles('var(---ztv-black)', 'var(--ztv-lighter-gray)', '1px solid var(--ztv-light-gray)');
    } else {
      this.setStyles('var(--ztv-white)', 'var(--ztv-blue)', '1px solid var(--ztv-blue)');
    }
  }

  onMouseLeave(): void {
    this.noMouse();
  }

  private noMouse(): void {
    if (!this.status().hasStatus(AnzeigeStatusEnum.PUBLISHED)) {
      this.setStyles('var(--ztv-lighter-gray)', 'var(---ztv-black)', '');
    } else {
      this.setStyles('var(--ztv-blue)', 'var(--ztv-white)', '');
    }
  }

  private setStyles(background: string, color: string, border: string): void {
    this.elementRef.nativeElement.class = 'overlay';

    this.elementRef.nativeElement.style.backgroundColor = background;
    this.elementRef.nativeElement.style.color = color;
    this.elementRef.nativeElement.style.border = border;
  }
}

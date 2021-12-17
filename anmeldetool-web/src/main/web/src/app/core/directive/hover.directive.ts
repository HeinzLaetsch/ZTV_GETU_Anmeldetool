import {
  Directive,
  ElementRef,
  HostListener,
  Input,
  OnChanges,
  SimpleChanges,
} from "@angular/core";
import { Anzeigestatus, AnzeigeStatusEnum } from "../model/AnzeigeStatusEnum";

@Directive({
  selector: "[hover]",
})
export class HoverOverDirective implements OnChanges {
  @Input()
  status: Anzeigestatus;
  constructor(private elementRef: ElementRef) {}
  ngOnChanges(changes: SimpleChanges): void {
    this.noMouse();
  }

  // @HostBinding("class")
  // className = "overlay";

  @HostListener("mouseenter") onMouseEnter() {
    if (!this.status.hasStatus(AnzeigeStatusEnum.PUBLISHED)) {
      this.setStyles(
        "var(---ztv-black)",
        "var(--ztv-lighter-gray)",
        "1px solid var(--ztv-light-gray)"
      );
    } else {
      this.setStyles(
        "var(--ztv-white)",
        "var(--ztv-blue)",
        "1px solid var(--ztv-blue)"
      );
    }
  }

  @HostListener("mouseleave") onMouseLeave() {
    this.noMouse();
  }

  private noMouse() {
    if (!this.status.hasStatus(AnzeigeStatusEnum.PUBLISHED)) {
      this.setStyles("var(--ztv-lighter-gray)", "var(---ztv-black)", "");
    } else {
      this.setStyles("var(--ztv-blue)", "var(--ztv-white)", "");
    }
  }

  private setStyles(background: string, color: string, border: string) {
    this.elementRef.nativeElement.class = "overlay";

    this.elementRef.nativeElement.style.backgroundColor = background;
    this.elementRef.nativeElement.style.color = color;
    this.elementRef.nativeElement.style.border = border;
  }
}

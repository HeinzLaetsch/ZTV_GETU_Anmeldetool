import {
  Directive,
  ElementRef,
  HostListener,
  Input,
  OnChanges,
  SimpleChanges,
} from "@angular/core";
import { AnzeigeStatusEnum } from "../model/AnzeigeStatusEnum";

@Directive({
  selector: "[hover]",
})
export class HoverOverDirective implements OnChanges {
  @Input()
  status: AnzeigeStatusEnum;
  constructor(private elementRef: ElementRef) {}
  ngOnChanges(changes: SimpleChanges): void {
    switch (this.status) {
      case AnzeigeStatusEnum.OK:
        this.setStyles("#488dd6", "#ffff", "");
        break;
      case AnzeigeStatusEnum.WARNUNG:
        this.setStyles("#488d00", "#ffff", "");
        break;
      case AnzeigeStatusEnum.ERROR:
        this.setStyles("#FF0000", "#ffff", "");
        break;
      default: {
      }
    }
  }

  @HostListener("mouseenter") onMouseEnter() {
    switch (this.status) {
      case AnzeigeStatusEnum.OK:
        this.setStyles("#ffff", "#488dd6", "1px solid #488dd6");
        break;
      case AnzeigeStatusEnum.WARNUNG:
        this.setStyles("#ffff", "#488d00", "1px solid #488d00");
        break;
      case AnzeigeStatusEnum.ERROR:
        this.setStyles("#ffff", "#FF0000", "1px solid #FF0000");
        break;
      default: {
      }
    }
  }

  @HostListener("mouseleave") onMouseLeave() {
    switch (this.status) {
      case AnzeigeStatusEnum.OK:
        this.setStyles("#488dd6", "#ffff", "");
        break;
      case AnzeigeStatusEnum.WARNUNG:
        this.setStyles("#488d00", "#ffff", "");
        break;
      case AnzeigeStatusEnum.ERROR:
        this.setStyles("#FF0000", "#ffff", "");
        break;
      default: {
      }
    }
  }

  private setStyles(background: string, color: string, border: string) {
    this.elementRef.nativeElement.style.backgroundColor = background;
    this.elementRef.nativeElement.style.color = color;
    this.elementRef.nativeElement.style.border = border;
  }
}

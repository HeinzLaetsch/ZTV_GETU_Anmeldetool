import { AgPromise, IHeaderComp, IHeaderParams } from "ag-grid-community";
// https://plnkr.co/edit/?open=main.js&preview
export class AnlassHeaderComponent implements IHeaderComp {
  agParams;
  eGui;
  eMenuButton;
  eSortDownButton;
  eSortUpButton;
  eSortRemoveButton;
  onMenuClickListener;
  onSortAscRequestedListener;
  onSortDescRequestedListener;
  onRemoveSortListener;
  onSortChangedListener;

  refresh(params: IHeaderParams<any>): boolean {
    throw new Error("Method not implemented.");
  }
  getGui(): HTMLElement {
    return this.eGui;
  }

  onSortRequested(order, event) {
    this.agParams.setSort(order, event.shiftKey);
  }

  onMenuClick() {
    this.agParams.showColumnMenu(this.eMenuButton);
  }

  destroy() {
    if (this.onMenuClickListener) {
      this.eMenuButton.removeEventListener("click", this.onMenuClickListener);
    }
    this.eSortDownButton.removeEventListener(
      "click",
      this.onSortAscRequestedListener
    );
    this.eSortUpButton.removeEventListener(
      "click",
      this.onSortDescRequestedListener
    );
    this.eSortRemoveButton.removeEventListener(
      "click",
      this.onRemoveSortListener
    );
    this.agParams.column.removeEventListener(
      "sortChanged",
      this.onSortChangedListener
    );
  }

  init(agParams) {
    this.agParams = agParams;
    this.eGui = document.createElement("div");
    this.eGui.innerHTML = `
            <div class="customHeaderMenuButton">
                <i class="fa ${this.agParams.menuIcon}"></i>
            </div>
            <div>${this.agParams.displayName}</div>
            <div>line 2</div>
            <div class="customSortDownLabel inactive">
                <i class="fa fa-long-arrow-alt-down"></i>
            </div>
            <div class="customSortUpLabel inactive">
                <i class="fa fa-long-arrow-alt-up"></i>
            </div>
            <div class="customSortRemoveLabel inactive">
                <i class="fa fa-times"></i>
            </div>
        `;

    this.eMenuButton = this.eGui.querySelector(".customHeaderMenuButton");
    this.eSortDownButton = this.eGui.querySelector(".customSortDownLabel");
    this.eSortUpButton = this.eGui.querySelector(".customSortUpLabel");
    this.eSortRemoveButton = this.eGui.querySelector(".customSortRemoveLabel");

    /*
    if (this.agParams.enableMenu) {
      this.onMenuClickListener = this.onMenuClick.bind(this);
      this.eMenuButton.addEventListener("click", this.onMenuClickListener);
    } else {
      this.eGui.removeChild(this.eMenuButton);
    }

    if (this.agParams.enableSorting) {
      this.onSortAscRequestedListener = this.onSortRequested.bind(this, "asc");
      this.eSortDownButton.addEventListener(
        "click",
        this.onSortAscRequestedListener
      );
      this.onSortDescRequestedListener = this.onSortRequested.bind(
        this,
        "desc"
      );
      this.eSortUpButton.addEventListener(
        "click",
        this.onSortDescRequestedListener
      );
      this.onRemoveSortListener = this.onSortRequested.bind(this, null);
      this.eSortRemoveButton.addEventListener(
        "click",
        this.onRemoveSortListener
      );

      this.onSortChangedListener = this.onSortChanged.bind(this);
      this.agParams.column.addEventListener(
        "sortChanged",
        this.onSortChangedListener
      );
      this.onSortChanged();
    } else {
      this.eGui.removeChild(this.eSortDownButton);
      this.eGui.removeChild(this.eSortUpButton);
      this.eGui.removeChild(this.eSortRemoveButton);
    }*/
  }
}

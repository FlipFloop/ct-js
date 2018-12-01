room-backgrounds-editor.room-editor-Backgrounds.tabbed.tall
    ul
        li.bg(each="{background, ind in opts.room.backgrounds}" oncontextmenu="{onContextMenu}")
            img(src="{background.graph === -1? '/img/nograph.png' : (glob.graphmap[background.graph].src.split('?')[0] + '_prev.png?' + glob.graphmap[background.graph].g.lastmod)}" onclick="{onChangeBgGraphic}")
            span 
                span(class="{active: detailedBackground === background}" onclick="{editBackground}")
                    .icon-settings
                | {glob.graphmap[background.graph].g.name} ({background.depth})
            .clear
            div(if="{detailedBackground === background}")
                .clear
                label
                    b {voc.depth}
                    input.wide(type="number" value="{background.depth || 0}" step="0" oninput="{onChangeBgDepth}")
                
                b {voc.shift}
                .clear
                label.fifty.npl.npt
                    input.wide(type="number" value="{background.extends.shiftX || 0}" step="8" oninput="{wire('this.detailedBackground.extends.shiftX')}")
                label.fifty.npr.npt
                    input.wide(type="number" value="{background.extends.shiftY || 0}" step="8" oninput="{wire('this.detailedBackground.extends.shiftY')}")
                
                b {voc.scale}
                .clear
                label.fifty.npl.npt
                    input.wide(type="number" value="{background.extends.scaleX || 1}" step="0.01" oninput="{wire('this.detailedBackground.extends.scaleX')}")
                label.fifty.npr.npt
                    input.wide(type="number" value="{background.extends.scaleY || 1}" step="0.01" oninput="{wire('this.detailedBackground.extends.scaleY')}")
                
                b {voc.movement}
                .clear
                label.fifty.npl.npt
                    input.wide(type="number" value="{background.extends.movementX || 0}" step="0.1" oninput="{wire('this.detailedBackground.extends.movementX')}")
                label.fifty.npr.npt
                    input.wide(type="number" value="{background.extends.movementY || 0}" step="0.1" oninput="{wire('this.detailedBackground.extends.movementY')}")
                
                b {voc.parallax}
                .clear
                label.fifty.npl.npt
                    input.wide(type="number" value="{background.extends.parallaxX || 1}" step="0.01" oninput="{wire('this.detailedBackground.extends.parallaxX')}")
                label.fifty.npr.npt
                    input.wide(type="number" value="{background.extends.parallaxY || 1}" step="0.01" oninput="{wire('this.detailedBackground.extends.parallaxY')}")
                .clear


    button.inline.wide(onclick="{addBg}")
        i.icon-plus
        span {voc.add}
    graphic-selector(ref="graphPicker" if="{pickingBackground}" oncancelled="{onGraphCancel}" onselected="{onGraphSelected}")
    script.
        const gui = require('nw.gui');
        this.pickingBackground = false;
        this.namespace = 'roombackgrounds';
        this.mixin(window.riotVoc);
        this.mixin(window.riotWired);
        this.onGraphSelected = graph => e => {
            this.editingBackground.graph = graph.uid;
            this.pickingBackground = false;
            this.creatingBackground = false;
            this.update();
            this.parent.refreshRoomCanvas();
        };
        this.onGraphCancel = e => {
            this.pickingBackground = false;
            if (this.creatingBackground) {
                let bgs = this.opts.room.backgrounds;
                bgs.splice(bgs.indexOf(this.editingBackground), 1);
                this.creatingBackground = false;
            }
            this.update();
        };
        this.addBg = function () {
            var newBg = {
                depth: 0,
                graph: -1,
                extends: {}
            };
            this.opts.room.backgrounds.push(newBg);
            this.editingBackground = newBg;
            this.pickingBackground = true;
            this.creatingBackground = true;
            this.opts.room.backgrounds.sort(function (a, b) {
                return a.depth - b.depth;
            });
            this.update();
        };
        this.onContextMenu = e => {
            this.editedBg = Number(e.item.ind);
            roomBgMenu.popup(e.clientX, e.clientY);
            e.preventDefault();
        };
        var roomBgMenu = new gui.Menu();
        roomBgMenu.append(new gui.MenuItem({
            label: window.languageJSON.common.delete,
            click: () => {
                this.opts.room.backgrounds.splice(this.editedBg, 1);
                this.parent.refreshRoomCanvas();
                this.update();
            }
        }));
        this.onChangeBgGraphic = e => {
            this.pickingBackground = true;
            this.editingBackground = e.item.background;
            this.update();
        };
        this.onChangeBgDepth = e => {
            e.item.background.depth = Number(e.target.value);
            this.opts.room.backgrounds.sort(function (a, b) {
                return a.depth - b.depth;
            });
            this.parent.refreshRoomCanvas();
        };

        this.editBackground = e => {
            console.log(e);
            if (this.detailedBackground === e.item.background) {
                this.detailedBackground = void 0;
            } else {
                this.detailedBackground = e.item.background;
                if (!('extends' in this.detailedBackground)) {
                    this.detailedBackground.extends = {};
                }
            }
        };
## Memo

* helper
  * top_page
  * link_to_page
  * page_for, resource_for
  * aks, aks_controllerq
  * link_to_archives
  * breadcrumbs
* Sitemap::Resource
  * title, date
  * is_top_page?
  * summary_text
* controller
  * site_tree, index_creator, archives

  

## TODO

* summary の作成
  * タイトルのみリストアップ型
  * 要約表示型
* 低優先度
  * pager, paginate
  * partial or helper for share_sns
  * tags

## master

### 0.0.6

* partial/_share_sns.erb 追加。はてブとtwitterのみ

### 0.0.5

* released 2015-4-10
* page attributes 復活
  * .date, .title, is_top_page? を Sitemap::Resource に追加
  * summary_text(). gem 'nokogiri'
* index_summary.html.erb：child folder/pages に分け、pages は summary を表示するように
  * partial/_summary.erb をいじる
  * aks_settings.numbering_headings を加える。
* article.erb layout 廃止。page.erb に統一  
* breadcrumbs を site_tree に統合
* helper の追加、after_configuration, ready フックは processor クラスでやることに

### 0.0.4

* released 2015-4-9
* /index.html がない場合の対処を追加
  * top page かの判定を path 名でするように（index.htmlがない時のため）
  * index_creator: index.html がない時は index template に従って作る

### 0.0.3

* released 2015-4-8
* PageAttributes 廃止。Utils::page_title(page), page_date(page) へ。
* site_treeでの make_tree を manipulate_resource_list ではなく ready に


### 0.0.2

* released 2015-4-7
* resource に PageAttributes::InstanceMethodsToResource を extend させる方式
  * akg.pages がそうだと ensure できないので、廃止するかも
  
### 0.0.1


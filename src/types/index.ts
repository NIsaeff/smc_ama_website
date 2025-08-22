export interface Event {
  id: string;
  title: string;
  date: string;
  location: string;
  description?: string;
  link: string;
}

export interface BlogPost {
  id: string;
  title: string;
  image: string;
  excerpt?: string;
  content?: string;
  publishedAt: string;
}
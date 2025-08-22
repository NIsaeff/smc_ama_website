import { Event, BlogPost } from '../types';

const API_BASE = '/api';

export const api = {
  async getEvents(): Promise<Event[]> {
    const response = await fetch(`${API_BASE}/events`);
    if (!response.ok) {
      throw new Error('Failed to fetch events');
    }
    return response.json();
  },

  async getBlogPosts(): Promise<BlogPost[]> {
    const response = await fetch(`${API_BASE}/blog-posts`);
    if (!response.ok) {
      throw new Error('Failed to fetch blog posts');
    }
    return response.json();
  },

  async healthCheck(): Promise<{ status: string; timestamp: string }> {
    const response = await fetch(`${API_BASE}/health`);
    if (!response.ok) {
      throw new Error('Health check failed');
    }
    return response.json();
  }
};